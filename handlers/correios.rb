# frozen_string_literal: false

require 'correios_br'

module Lita
  module Handlers
    # Public: A class that implements CorreiosBr to use as a handler
    class Correios < Handler
      route(
        %r{/address},
        :address,
        command: false, # if true, force the message to be prefixed with @BotName
        help: { address: 'responde com o endereço do cep.' }
      )

      def address(response)
        cep = response.args.first&.strip
        address_hash = CorreiosBr::CEP.get_address(cep)
        result = parse_hash(address_hash)

        response.reply(result)
      end

      def parse_hash(address_hash)
        new_hash = address_hash.slice(:zipcode, :address, :complement, :neighborhood, :city, :state, :ibge)

        result = "Address\n"
        new_hash.each do |k, v|
          result << "#{k}: #{v}\n"
        end
        result
      end

      Lita.register_handler(self)
    end
  end
end
