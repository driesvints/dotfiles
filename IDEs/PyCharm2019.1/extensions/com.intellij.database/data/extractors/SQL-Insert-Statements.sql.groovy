SEP = ", "
QUOTE     = "\'"
NEWLINE   = System.getProperty("line.separator")

KEYWORDS_LOWERCASE = com.intellij.database.util.DbSqlUtil.areKeywordsLowerCase(PROJECT)
KW_INSERT_INTO = KEYWORDS_LOWERCASE ? "insert into " : "INSERT INTO "
KW_VALUES = KEYWORDS_LOWERCASE ? ") values (" : ") VALUES ("
KW_NULL = KEYWORDS_LOWERCASE ? "null" : "NULL"

def record(columns, dataRow) {
    OUT.append(KW_INSERT_INTO)
    if (TABLE == null) OUT.append("MY_TABLE")
    else OUT.append(TABLE.getParent().getName()).append(".").append(TABLE.getName())
    OUT.append(" (")

    columns.eachWithIndex { column, idx ->
        OUT.append(column.name()).append(idx != columns.size() - 1 ? SEP : "")
    }

    OUT.append(KW_VALUES)
    columns.eachWithIndex { column, idx ->
        def value = dataRow.value(column)
        def skipQuote = value.toString().isNumber() || value == null
        def stringValue = value != null ? FORMATTER.format(dataRow, column) : KW_NULL
        if (DIALECT.getFamilyId().isMysql()) stringValue = stringValue.replace("\\", "\\\\")
        OUT.append(skipQuote ? "": QUOTE).append(stringValue.replace(QUOTE, QUOTE + QUOTE))
           .append(skipQuote ? "": QUOTE).append(idx != columns.size() - 1 ? SEP : "")
    }
    OUT.append(");").append(NEWLINE)
}

ROWS.each { row -> record(COLUMNS, row) }
