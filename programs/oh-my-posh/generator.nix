# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/JanDeDobbeleer/oh-my-posh
# ==============================================================================
{ lib, ... }:
with lib;
let

  # sortAndFilter sorts the list by each element's `priority` attribute,
  # omitting entries which have their `enable` attribuet set to `false`
  #
  # sortAndFilter :: attrset -> attrset
  sortAndFilter = attrs:
    builtins.sort
      (a: b: (getPriority a) < (getPriority b))
      (builtins.filter (a: getEnable a) attrs);

  # flattenSegments recursively flattens segments nested within segments,
  # evaluating their enablement and priority within each nested group.
  #
  # Example input:
  #
  #   [
  #     {
  #       segments = [
  #         {
  #           priority = 100;
  #           template = "bar";
  #         }
  #         {
  #           priority = 10;
  #           template = "foo";
  #         }
  #       ]
  #     }
  #     {
  #       template = "baz";
  #     }
  #   ]
  #
  # Example output:
  #
  #   [
  #     {
  #       template = "foo";
  #     }
  #     {
  #       template = "bar";
  #     }
  #     {
  #       template = "baz";
  #     }
  #   ]
  #
  flattenSegments = segmentList: lib.lists.flatten
    (map
      (segment:
        if segment ? "segments"
        then (mkSegments segment.segments)
        else [ segment ]
      )
      segmentList);

  # getPriority returns the declared priority of the block/segment, defaulting
  # to 0 if unspecified.
  #
  # getPriority :: { priority: int } -> int
  getPriority = a: if a ? "priority" then a.priority else 0;

  # getEnable returns the declared enable property of the block/segment,
  # defaulting to true if unspecified.
  #
  # getPriority :: { enable: bool } -> bool
  getEnable = a: if a ? "enable" then a.enable else true;

  # cleanAttrs removes the `enable` and `priority` properties from
  # the provided attribute set, along with any null values.
  #
  # cleanAttrs :: attrs -> attrs
  cleanAttrs =
    lib.attrsets.filterAttrs (k: v: (k != "enable" && k != "priority" && v != null));

  mkSegments = segments:
    let
      segmentList =
        if builtins.typeOf segments == "list"
        then segments
        else builtins.attrValues segments;
      cleanSegmentList = map cleanAttrs (sortAndFilter segmentList);
    in
    flattenSegments cleanSegmentList;

  mkSegmentsInBlock = { segments, ... } @ block:
    block // { segments = mkSegments segments; };

  mkBlocks = blocks:
    let
      blockList =
        if builtins.typeOf blocks == "list"
        then blocks
        else builtins.attrValues blocks;
      cleanBlockList = map cleanAttrs (sortAndFilter blockList);
    in
    map mkSegmentsInBlock cleanBlockList;

in
{
  blockType = ompBlockType;
  segmentType = ompSegmentType;

  inherit flattenSegments;
  inherit mkSegments;
  inherit mkBlocks;
}
