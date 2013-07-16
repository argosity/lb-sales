module Hashie
  module HashExtensions
    def self.included(base)
      # Don't tread on existing extensions of Hash by
      # adding methods that are likely to exist.
      %w(stringify_keys stringify_keys!).each do |hashie_method|
        base.send :alias_method, hashie_method, "hashie_#{hashie_method}" unless base.instance_methods.include?(hashie_method)
      end
    end

    # Destructively convert all of the keys of a Hash
    # to their string representations.
    def hashie_stringify_keys!
      self.keys.each do |k|
        unless String === k
          self[k.to_s] = self.delete(k)
        end
      end
      self
    end

    # Convert all of the keys of a Hash
    # to their string representations.
    def hashie_stringify_keys
      self.dup.stringify_keys!
    end

    # Convert this hash into a Mash
    def to_mash
      ::Hashie::Mash.new(self)
    end
  end

  module PrettyInspect
    def self.included(base)
      base.send :alias_method, :hash_inspect, :inspect
      base.send :alias_method, :inspect, :hashie_inspect
    end

    def hashie_inspect
      ret = "#<#{self.class.to_s}"
      stringify_keys.keys.sort.each do |key|
        ret << " #{key}=#{self[key].inspect}"
      end
      ret << ">"
      ret
    end
  end
end

module Hashie
  # A Hashie Hash is simply a Hash that has convenience
  # functions baked in such as stringify_keys that may
  # not be available in all libraries.
  class Hash < ::Hash
    include HashExtensions

    # Converts a mash back to a hash (with stringified keys)
    def to_hash(options={})
      out = {}
      keys.each do |k|
        if self[k].is_a?(Array)
          k = options[:symbolize_keys] ? k.to_sym : k.to_s
          out[k] ||= []
          self[k].each do |array_object|
            out[k] << (Hash === array_object ? array_object.to_hash : array_object)
          end
        else
          k = options[:symbolize_keys] ? k.to_sym : k.to_s
          out[k] = Hash === self[k] ? self[k].to_hash : self[k]
        end
      end
      out
    end

    # The C geneartor for the json gem doesn't like mashies
    def to_json(*args)
      to_hash.to_json(*args)
    end
  end
end
