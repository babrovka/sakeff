# Tests whenever users can interact with units via a jstree
shared_examples :units_tree_viewable do
  before(:each) do
    sleep(3)
  end

  describe 'at start', js: true do
    it 'already has several opened nodes at start' do
      expect(page.all(".js-units-tree-container .jstree-node").count).to be > 1
    end

    it "displays units in a correct structure" do
      all('.jstree-ocl').last.click
      sleep(3)

      node = page.find '.jstree-anchor', text: unit.label
      container = node.find(:xpath, '..')
      within(container) do
        expect(page).to have_text child_unit.label
      end

      child_node = page.find '.jstree-anchor', text: grandchild_unit.label
      child_container = child_node.find(:xpath, '..')

      within(child_container) do
        expect(page).to have_text grandchild_unit.label
      end
    end
  end

  describe 'clicking on them', js: true do
    it 'hides a node' do
      first(".jstree-ocl").click
      sleep(3)

      expect(page.all(".jstree-ocl").count).to eq(1)
    end

    it 'opens a node' do
      visit current_path

      first(".jstree-ocl").click
      first(".jstree-ocl").click
      expect(page.all(".jstree-node").count).to be > 1
    end
  end
end
