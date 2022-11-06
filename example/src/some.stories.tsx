import { DocsContainerProps, DocsContextProps } from "@storybook/addon-docs";
import { Meta, StoryFn  } from "@storybook/react";
import { AnyFramework, LoaderFunction, PlayFunction, StoryContextForLoaders } from "@storybook/types";
import { ReactFragment } from "react";
import { userEvent, within } from "@storybook/testing-library";


const loader: LoaderFunction<AnyFramework, any> = () => Promise.resolve({})

const play : PlayFunction<any, {}> = async () => {}



export default {
  // parameters: { docs },
  play,
  argTypes: {
    control:
  }

} as Meta;
