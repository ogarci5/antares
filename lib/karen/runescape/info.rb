module Karen
  module Runescape
    class Info < Karen::Model::Base
      attr_accessible id: :id, day: :day

      attribute :day

      def self.update_from_api!
        info = all.to_a.first
        info_params = { day: API.info.try(:[], 'lastConfigUpdateRuneday') }

        if info.try(:day) != info_params[:day]
          Karen::Notification::Message.generate(type: base_module, text: 'Grand Exchange info').deliver
        end

        if info
          info.update(info_params)
        else
          create(info_params)
        end
      end

      def to_s
        "Runeday #{day}"
      end
    end
  end
end
