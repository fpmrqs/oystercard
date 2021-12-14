require 'oystercard'

describe Oystercard do
  it { expect(subject).to respond_to(:balance) }

  it { expect(subject).to respond_to(:top_up) }

  it "tops up the balance by 5" do  
    expect { subject.top_up(5) }.to change { subject.balance }.from(0).to(5)
  end

  context "touches in with a balance of 5" do
    before do 
      subject.top_up(5) 
      subject.touch_in
    end

    it ":deducts works in private" do
      expect { subject.send(:deduct, Oystercard::MINIMUM_FARE) }.to change { subject.balance }.from(5).to(4)
    end

    it "touches in" do
      expect(subject.in_journey?).to eq true
    end
    
    it "deducts fare amount when user touches_out" do
      expect { subject.touch_out }.to change{ subject.balance }.by(-1)
    end

    it "touches out" do
      subject.touch_out
      expect(subject.in_journey?).to eq false
    end
  end

  it "prevents top up above max limit" do
    expect {subject.top_up(91)}.to raise_error "Max limit of #{subject.limit} reached"
  end

  it "checks if you are in_journey" do
    expect(subject).to respond_to(:in_journey?)
  end

  it "gives error if touches in whilst balance below minimum" do
    expect {subject.touch_in}.to raise_error "Min balance of £1 required"
  end

  # touch_in -----> @in_journey == true -----> touch_out -----> @in_journey == false
end