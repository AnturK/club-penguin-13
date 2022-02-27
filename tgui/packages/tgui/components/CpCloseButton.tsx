import { useDispatch } from "common/redux";
import { backendSuspendStart } from "../backend";
import { CpButton } from "./CpButton";

export const CpCloseButton = (props, context) => {
  const dispatch = useDispatch(context);

  const close = () => {
    dispatch(backendSuspendStart());
  };

  return (
    <CpButton
      extraClasses={["Button__clubpenguin-close"]}
      onClick={close}
    >
      X
    </CpButton>
  );
};
