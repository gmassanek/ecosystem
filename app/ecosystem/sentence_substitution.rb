module Ecosystem
  class SentenceSubstitution
    
    def self.populate(sentence, sub_val_1, sub_val_2)
      sentence.sub("%1", sub_val_1).sub("%2", sub_val_2)
    end
    
  end
end
