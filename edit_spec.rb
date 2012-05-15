# edit_test.rb
# usage: ruby -r klass.rb edit_test.rb <iter> \
#        [<constructor> [<lines> <columns>] ...]

# disable plymouth by default
# if ENV["USE_PLYMOUTH"].nil?
#   ENV["USE_PLYMOUTH"] = "no"
# end

require 'bundler'
Bundler.require

require './edit'

# PryExceptionExplorer.enabled = true
# PryExceptionExplorer.intercept(Exception)

describe GapBuffer do
  describe "#insert_before" do
    it "inserts characters" do
      subject.insert_before ?h
      subject.insert_before ?e
      subject.insert_before ?l
      # subject.insert_before ?l
      subject.insert_before ?o
      subject.to_s.should == "hello"
    end

    it "resizes buffer gap" do
      chars = (?a..?z).to_a
      100.times { |i| subject.insert_before(chars[i%26]) }
      subject.to_s.length.should == 100
    end
  end

  describe "#insert_after" do
    it "inserts characters in reverse order" do
      subject.insert_after ?h
      subject.insert_after ?e
      subject.insert_after ?l
      subject.insert_after ?l
      subject.insert_after ?o
      subject.to_s.should == "olleh"
    end

    it "resizes buffer gap" do
      chars = (?a..?z).to_a
      100.times { |i| subject.insert_after(chars[i%26]) }
      subject.to_s.length.should == 100
    end
  end

  describe "#delete_before" do
    it "removes the character" do
      subject.insert_string "hello"
      subject.delete_before
      subject.to_s.should == "hell"
    end
  end

  describe "#delete_after" do
    it "removes the character" do
      subject.insert_string "hello"
      subject.left
      subject.left
      subject.delete_after
      subject.to_s.should == "helo"
    end
  end

  describe "#left" do
    it "moves the insertion point" do
      subject.insert_string "helo"
      subject.left
      subject.insert_before ?l
      subject.to_s.should == "hello"
    end

    it "can't move left of beginning" do
      subject.insert_before ?i
      subject.left
      subject.left
      subject.insert_before ?h
      subject.to_s.should == "hi"
    end
  end

  describe "#right" do
    it "moves the insertion point" do
      subject.insert_after ?l
      subject.insert_after ?e
      subject.insert_after ?h
      subject.right
      subject.right
      subject.right

      subject.insert_before ?l
      subject.insert_before ?o
      subject.to_s.should == "hello"
    end

    it "does not fall off the end" do
      subject.insert_before ?h
      subject.right
      subject.insert_before ?i
      subject.to_s.should == "hi"
    end
  end

  describe "#up" do
    it "moves cursor up one line" do
      subject.insert_string "line one\n"
      subject.insert_string "line two\n"
      subject.up
      subject.insert_string "this is "
      subject.to_s.should == "line one\nthis is line two\n"
    end

    it "doesn't move past the first line" do
      subject.insert_string "line one "
      subject.up
      subject.insert_string "more text"
      subject.to_s.should == "line one more text"
    end
  end

  describe "#down" do
    it "moves cursor down one line" do
      subject.insert_string "line one\n"
      subject.insert_string "line\n"
      10.times { subject.left }
      subject.down
      subject.insert_string " tooth"
      subject.to_s.should == "line one\nline two\n"
    end
  end
end
