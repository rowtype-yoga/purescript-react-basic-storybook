import * as React from "react";

export default function Checkbox(props) {
  return <input checked={props.checked} style={{ transform: "translateY(1.5px)" }} type="checkbox" />
}
