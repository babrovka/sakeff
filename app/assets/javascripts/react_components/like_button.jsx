/** @jsx React.DOM */

var LikeButton = React.createClass({
   getDefaultProps: function() {
     return {liked: false};
   },

   getInitialState: function(props) {
     props = props || this.props;
     return {liked: props.liked};
   },

   componentWillReceiveProps: function(newProps, oldProps) {
     this.setState(this.getInitialState(newProps));
   },


   handleClick: function(event) {
     this.setState({liked: !this.state.liked});
   },

   render: function() {

     var text = this.state.liked ? 'like' : 'unlike';
     return (
     <p onClick={this.handleClick}>
         <span>You { text } this.Click to toggle.</span>
         <span dangerouslySetInnerHTML={{__html: this.props.html}}></span>
     </p>
     );
   }
});
