using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerModels.PDFDocumentEditorModel
{
    public class DataSourceDetailsInputModel
    {
        public string _id { get; set; }
        public string TemplateId { get; set; }
        public DataSourceMongoQuery DataSourceMongoQuery  {get;set;}
        public List<DataSorceParams> DataSorceParamsType { get; set; }
        public List<DataSourceDummyParamValues> DataSourceDummyParamValues { get; set; }
        public bool Update { get; set; }
        public bool Archive { get; set; }
    }

    public class DataSourceMongoQuery
    {
        public string DataSource { get; set; }
        public string Database { get; set; }
        public string MongoQuery { get; set; }
        public string MongoQueryWithDummyValues { get; set; }


    }

    public class DataSorceParams
    {
        public string Name { get; set; }
        public string Type { get; set; }

    }

    public class DataSourceDummyParamValues
    {
        public string Name { get; set; }
        public string Value { get; set; }
    }
    public class MongoQueryInputModel
    {
        public string MongoQuery { get; set; }
        public List<DataSorceParams> DataSorceParamsType { get; set; }
        public List<DataSourceDummyParamValues> DataSourceParamValues { get; set; }
        public string MongoCollectionName { get; set; }
    }
    public class HtmlToSfdtConversionModel
    {
        public string HtmlFile { get; set; }
    }
}
