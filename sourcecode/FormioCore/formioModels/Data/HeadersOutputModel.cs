using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Data
{
    public class HeadersOutputModel
    {
        public string Field { get; set; }
        public string ColumnAltName { get; set; }
        public string HeaderBackgroundColor { get; set; }
        public string HeaderFontColor { get; set; }
        public string ColumnBackgroundColor { get; set; }
        public string ColumnFontFamily { get; set; }
        public string ColumnFontColor { get; set; }
        public string RowBackgroundColor { get; set; }

        public string Width { get; set; }

        public string Title { get; set; }

        public string Filter { get; set; }

        public bool Hidden { get; set; }

        public int MaxLength { get; set; }

        public bool IsNullable { get; set; }

        public bool IncludeInFilters { get; set; }

        public string QueryVariable { get; set; }

        public string SubQuery { get; set; }

        public string SubQueryType { get; set; }

        public Guid? SubQueryTypeId { get; set; }

        public Guid? ColumnFormatTypeId { get; set; }
        public string ColumnFormatType { get; set; }

        public bool? IsAvailableForFiltering { get; set; }

        public string ColumnName { get; set; }

        public string ColumnType { get; set; }

    }

    [BsonIgnoreExtraElements]
    public class ColumnInfo
    {
        public string columnName { get; set; }
        public string dataType { get; set; }
        //public int length { get; set; }
    }
}
