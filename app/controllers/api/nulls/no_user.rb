class UserController
  class NoUser
    attr_reader :user

    def initializer(user)
      @user = user
    end

    def first_name
      '--'
    end

    def last_name
      '--'
    end

    def email
      'blank@blank.hr'
    end
  end
end
