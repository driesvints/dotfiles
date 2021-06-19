/*
 * Available context bindings:
 *   COLUMNS     List<DataColumn>
 *   ROWS        Iterable<DataRow>
 *   OUT         { append() }
 *   FORMATTER   { format(row, col); formatValue(Object, col) }
 *   TRANSPOSED  Boolean
 * plus ALL_COLUMNS, TABLE, DIALECT
 *
 * where:
 *   DataRow     { rowNumber(); first(); last(); data(): List<Object>; value(column): Object }
 *   DataColumn  { columnNumber(), name() }
 */


import java.util.regex.Pattern

NEWLINE = System.getProperty("line.separator")

pattern = Pattern.compile("[^\\w\\d]")
def escapeTag(name) {
  name = pattern.matcher(name).replaceAll("_")
  return name.isEmpty() || !Character.isLetter(name.charAt(0)) ? "_$name" : name
}
def printRow = { values, rowTag, namer, valueToString ->
  OUT.append("$NEWLINE<$rowTag>$NEWLINE")
  values.eachWithIndex { it, index ->
    def tag = namer(it, index)
    def str = valueToString(it)
    OUT.append("  <$tag>$str</$tag>$NEWLINE")
  }
  OUT.append("</$rowTag>")
}

OUT.append(
"""<?xml version="1.0" encoding="UTF-8"?>
<data>""")

if (!TRANSPOSED) {
  ROWS.each { row -> printRow(COLUMNS, "row", {it, _ -> escapeTag(it.name())}) { FORMATTER.format(row, it) } }
}
else {
  def values = COLUMNS.collect { new ArrayList<String>() }
  ROWS.each { row -> COLUMNS.eachWithIndex { col, i -> values[i].add(FORMATTER.format(row, col)) } }
  values.eachWithIndex { it, index -> printRow(it, escapeTag(COLUMNS[index].name()), { _, i -> "row${i + 1}" }, { it }) }
}

OUT.append("""
</data>
""")