export const toMeta = (meta) => {
  return { ...meta, component: meta.component() };
}

export const addPlayFunctionImpl = play => story => { story.play = play; return story }
