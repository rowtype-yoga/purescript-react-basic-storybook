import { userEvent, within } from '@storybook/testing-library';

export const withinImpl = within;

export function queryImpl(just) {
  return (nothing) => (query) => (elem) => {
    let result = query(elem)
    return result === null ? nothing : just(result)
  }
}

export const typeImpl = (elem,txt) => userEvent.type(elem, txt)
export const clickImpl = x => userEvent.click(x)
