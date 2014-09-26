shared_examples_for 'ringbell notifier object' do #|obj|

  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }

  before :each do
    Ringbell::Notification.destroy_all
  end

  it 'can get interesants' do
    expect(subject.interesants).to be_instance_of Array
  end

  it 'can have notifications' do
    expect(subject.notifications).to be_kind_of ActiveRecord::Relation
  end

  it 'can set/get class interesants' do
    old_interesants = subject.class.interesants

    expect {subject.class.interesants(:tst1, :tst2)}.to change {subject.class.interesants}.to([:tst1, :tst2])
    expect {subject.class.interesants *old_interesants}.to change {subject.class.interesants}.to(old_interesants)
  end

  it 'can set/get class engines' do
    old_engines = subject.class.engines

    expect {subject.class.engines(:tst1, :tst2)}.to change {subject.class.engines}.to([:tst1, :tst2])
    expect {subject.class.engines *old_engines}.to change {subject.class.engines}.to(old_engines)
  end

  it 'uses all engines when notifying' do
    subject.interesants.each do |u|
      subject.class.engines.each do |e|
        expect(e).to receive(:notify).with(u, subject, anything)
      end
    end

    subject.notify_interesants
  end

  context 'basic notifications tests' do
    before :each do
      expect {subject.notify_interesants}.to change {subject.notifications.count}.from(0).to(subject.interesants.count)
    end

    it 'can clear notifications' do
      expect {subject.clear_notifications}.to change{subject.notifications.count}.to(0)
    end

    it 'can clear notifications for specified user' do
      expect {subject.clear_notifications for: subject.interesants.first}.to change{subject.notifications_count_for subject.interesants.first}.from(1).to(0)
      expect(subject.notifications.count).to be == subject.interesants.count - 1
    end

    it 'can check if user have notification' do
      expect(subject.has_notification_for? subject.interesants.first).to be == true
    end

    it 'respects multiple notification setting' do
        if (subject.class.multiple_notifications)
          expect {subject.notify_interesants}.to change {subject.notifications.count}.from(subject.interesants.count).to(subject.interesants.count * 2)
        else
          expect {subject.notify_interesants}.not_to change {subject.notifications.count}
        end
    end

    it 'can get array of notifications for the user' do
      expect(subject.class.notifications_for user).to be_kind_of ActiveRecord::Relation
      expect((subject.class.notifications_for user).count).to be == 1
    end
  end

end