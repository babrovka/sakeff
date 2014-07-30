# Tests whenever users can interact with units via a jstree
shared_examples :units_tree_viewable do
  describe 'at start' do
    it 'has just one node' do
      expect(page.all(".jstree-node").count).to eq(1)
    end
  end

  describe 'clicking on them' do
    before { first(".jstree-ocl").click }

    it 'gets a new node' do
      expect(page.all(".jstree-node").count).to eq(2)
    end

    it 'hides a node' do
      first(".jstree-ocl").click

      expect(page.all(".jstree-ocl").count).to eq(1)
    end
  end
end