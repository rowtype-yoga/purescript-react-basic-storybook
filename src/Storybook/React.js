var storybook = require('@storybook/react');

exports.storiesOfImpl = function(stories) {
  return storybook.storiesOf(stories, module.parent);
}

exports.addImpl = function(sb) {
  return function(render) {
    return function(name) {
      return function() {
        return sb.add(name, render);
      }
    }
  }
}

exports.addDecoratorImpl = function(sb) {
  return function(addDeco) {
      return function() {
        return sb.addDecorator(function(storyFn) {
          return addDeco(storyFn)();
        });
      }
  }
}
