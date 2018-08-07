class CompanyController
  class NoCompany
    attr_reader :company

    def initializer(company)
      @company = company
    end

    def name
      '--'
    end
  end
end
