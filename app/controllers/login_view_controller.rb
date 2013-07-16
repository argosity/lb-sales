class LoginViewController < Formotion::FormController
    cattr_accessor :first_login
    self.first_login = true

    def init
        initWithForm(build_form)
        self.title = "LedgerBuddy - Login"
        submit( @form )
        @form.on_submit do |form|
            submit(form)
        end
        self
    end

    def viewDidLoad
        super
        return unless self.class.first_login

        if valid?
            submit(@form)
            self.class.first_login = false
        end
    end

    def submit(form)
        login_data = form.render
        server = login_data.delete(:server) + '.ledgerbuddy.dev'

        MotionResource::Base.root_url = "http://#{server}/api/"
        LedgerBuddy.server = server

        LedgerBuddy.when_reachable do

            if Customer.default_code || ! Location.default_code
                SVProgressHUD.showErrorWithStatus("Please fill in settings and make sure you are online")
            end

            UserSession.new(login_data).get_token do |response, json|

                SVProgressHUD.dismiss

                if response.ok?
                    if json.present?
                        Sku.tax # prime it so it's loaded by the time we need it

                        UIApplication.sharedApplication.delegate.window.rootViewController = DeckController.alloc.init
                    else
                        display_error
                    end
                else
                    UIAlertView.alert('Login Error', response.error_message)

                end
            end
        end
    end

    private

    def display_error
        UIAlertView.alert( 'Login Failed','Unable to reach Ledger Buddy server' )
    end

    def build_form
        @form ||= Formotion::Form.persist({
                persist_as: :credentials,
                sections: [{
                        rows: [{
                                title: 'Username',
                                key: :username,
                                type: :string,
                                auto_correction: :no,
                                auto_capitalization: :none,
                                value: ''
                            }, {
                                title: 'Password',
                                key: :password,
                                type: :string,
                                secure: true,
                                value: ''
                            }]
                    }, {
                        title: 'Account',
                        rows: [{
                                title: 'Server Prefix',
                                key: :server,
                                type: :string,
                                auto_correction: :no,
                                auto_capitalization: :none,
                                value: ''
                            }]
                    }, {
                        title: '',
                        rows: [{
                                title: 'Auto login',
                                key: :auto_login,
                                type: :switch,
                                value: false
                            }]
                    }, {
                        rows: [{
                                title: 'Save Settings',
                                type: :submit
                            }]
                    }]
            })
    end

    def valid?
        login_data = @form.render
        login_data[:server].present? && login_data[:email].present? && login_data[:password].present? && login_data[:auto_login]
    end

end
