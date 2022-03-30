import { Component } from "inferno";
import { useBackend } from "../backend";
import { dragStartHandler, recallWindowGeometry } from "../drag";
import { Layout } from "./Layout";

type CpWindowProps = {
  height: number,
  width: number,
  layoutProps?: CSSProperties,
};

export class CpWindow extends Component<CpWindowProps> {
  componentDidMount() {
    const { suspended } = useBackend(this.context);
    if (suspended) {
      return;
    }

    Byond.winset(window.__windowId__, {
      'can-close': true,
    });

    this.updateGeometry();
  }

  componentDidUpdate(prevProps) {
    const shouldUpdateGeometry = (
      this.props.width !== prevProps.width
      || this.props.height !== prevProps.height
    );

    if (shouldUpdateGeometry) {
      this.updateGeometry();
    }
  }

  updateGeometry() {
    recallWindowGeometry({
      size: [this.props.width, this.props.height],
    });
  }

  render() {
    const { suspended } = useBackend(this.context);

    return (
      <Layout
        className="Window"
        theme="clubpenguin"
        onMouseDown={dragStartHandler}
      >
        <Layout.Content style={this.props.layoutProps}>
          {!suspended && this.props.children}
        </Layout.Content>
      </Layout>
    );
  }
}
