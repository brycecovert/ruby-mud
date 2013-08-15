class Slot < ActiveRecord::Base
  def Slot.equipment_slots
    ['used as light', 'worn on finger', 'worn around neck', 'worn on torso', 'worn on head', 'worn on legs', 'worn on feet', 'worn on hands', 'worn on arms', 'worn as shield', 'worn about body', 'worn about waist', 'worn around wrist', 'wielded', 'held', 'floating nearby']
  end

  has_and_belongs_to_many :contents, :join_table => 'slots_contents', :class_name => 'Item'

end

