require 'sentence_substitution'

describe Ecosystem::SentenceSubstitution do
  it "substitutes two values in a sentence for the %1 and %2 in the sentence" do
    sentence = "%1 hello sir %2"
    Ecosystem::SentenceSubstitution.populate(sentence, "Why", "how are you?").should == "Why hello sir how are you?"
  end
end
