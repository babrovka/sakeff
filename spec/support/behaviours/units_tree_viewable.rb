# Tests whenever users can interact with units via a jstree
shared_examples :units_tree_viewable do
  describe 'at start' do
    it 'has several nodes at start' do
      expect(page.all(".jstree-node").count).to be > 1
    end
  end

  describe 'clicking on them' do
    before(:each) do
      visit current_path
    end

    it 'opens a node' do
      first(".jstree-ocl").click
      expect(page.all(".jstree-node").count).to be > 1
    end

    it 'hides a node' do
      first(".jstree-ocl").click
      sleep(5)
      first(".jstree-ocl").click
      expect(page.all(".jstree-ocl").count).to eq(1)
    end
  end
end
