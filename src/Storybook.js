export const toStory = (story) => {
  if (!story.component) return story;
  const component = story.component();
  return { ...story, component, render: args => story.render(component)(args) };
}

export const toMeta = (meta) => {
  const component = meta.component();
  return { ...meta, component };
}
