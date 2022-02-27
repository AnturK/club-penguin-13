import { classes } from "common/react";
import { SFC } from "inferno";
import { Button } from "./Button";

export const CpButton: SFC<{
  extraClasses?: string[],
  native?: Record<string, unknown>,
  onClick: () => void,
}> = (props) => {
  const {
    children,
    extraClasses = [],
    native = {},
    onClick,
  } = props;

  return (
    <Button
      className={classes(["Button__clubpenguin", ...extraClasses])}
      onClick={onClick}
      {...native}
    >
      <div className="inner1">
        <div className="inner2">
          {children}
        </div>
      </div>
    </Button>
  );
};
