# Tests whenever users can interact with units via a jstree
shared_examples :units_tree_viewable do

  describe 'at start', js: true do
    it 'already has several opened nodes at start' do
      expect(nodes_amount).to be > 1
    end

    it "displays units in a correct structure" do
      toggle_last_node

      node = node_with_text(unit.label)
      container = container_of_node(node)
      within(container) do
        expect(page).to have_text child_unit.label
      end

      child_node = node_with_text(grandchild_unit.label)
      child_container = container_of_node(child_node)

      within(child_container) do
        expect(page).to have_text grandchild_unit.label
      end
    end
  end

  describe 'clicking on them', js: true do
    it 'hides a node' do
      expect(nodes_amount).to be > 1
      toggle_first_node

      expect(nodes_amount).to eq(1)
    end

    it 'opens a node' do
      visit current_path
      toggle_first_node
      expect(nodes_amount).to eq 1

      toggle_first_node
      expect(nodes_amount).to be > 1
    end
  end
end

# Opens/closes first tree node
def toggle_first_node
  first(".jstree-ocl").click
end

# Opens/closes last tree node
def toggle_last_node
  all('.jstree-ocl').last.click
end

# Gets amount of all nodes on page
# @return [Integer]
def nodes_amount
  page.all(".jstree-node").count
end

# Finds node with certain text label
# @param text [String]
# @return [Capybara Selector] node
def node_with_text(text)
  page.find '.jstree-anchor', text: text
end

# Finds DOM container of node
# @param node [Capybara Selector]
# @return [Capybara Selector] DOM container
def container_of_node(node)
  node.find(:xpath, '..')
end
