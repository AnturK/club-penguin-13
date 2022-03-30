import { resolveAsset } from "../assets";
import { useBackend, useLocalState } from "../backend";
import { Box } from "../components";
import { CpCloseButton } from "../components/CpCloseButton";
import { CpWindow } from "../layouts/CpWindow";

const HEIGHT = 581;
const WIDTH = 881;

const MapSection = (props: {
  x: number,
  y: number,

  height: number,
  width: number,

  location: string,
}, context) => {
  const { act } = useBackend(context);
  const { x, y, height, width, location } = props;

  const [hovering, setHovering]
    = useLocalState(context, `hovering_${location}`, false);

  return (
    <Box
      position="absolute"
      style={{
        background: hovering && "rgba(255, 255, 0, 0.3)",
        "border-radius": "10%",
        cursor: "pointer",
        width: `${width}px`,
        height: `${height}px`,
        left: `${x}px`,
        top: `${y}px`,
      }}
      onClick={() => {
        act("teleport", {
          location,
        });
      }}
      onMouseOver={() => setHovering(true)}
      onMouseOut={() => setHovering(false)}
    />
  );
};

export const CpMap = (props, context) => {
  return (
    <CpWindow
      height={HEIGHT + 20}
      width={WIDTH + 20}
      layoutProps={{
        background: "white",
        border: "3px solid black",
      }}
    >
      <img
        src={resolveAsset("club-penguin-map.png")}
        useMap="#club-penguin-map"
        style={{
          position: "absolute",
          left: "5px",
          bottom: "7px",
        }}
      />

      <MapSection
        x={266}
        y={235}
        width={235}
        height={109}
        location="town"
      />

      <MapSection
        x={67}
        y={247}
        width={178}
        height={125}
        location="beach"
      />

      <MapSection
        x={521}
        y={193}
        width={160}
        height={90}
        location="plaza"
      />

      <MapSection
        x={726}
        y={155}
        width={89}
        height={70}
        location="cove"
      />

      <MapSection
        x={218}
        y={108}
        width={72}
        height={50}
        location="ski_village"
      />

      <MapSection
        x={766}
        y={98}
        width={115}
        height={58}
        location="iceberg"
      />

      <Box position="absolute" style={{
        top: "15px",
        right: "15px",
      }}>
        <CpCloseButton />
      </Box>
    </CpWindow>
  );
};
