module Exceptions
  class GenericApiError < StandardError
    def error_code
      self.class.name.demodulize
    end
  end

  class DeviceNotFound < GenericApiError; end
  class APIParameterMissing < GenericApiError; end
  class ClientNotFound < GenericApiError; end
end
