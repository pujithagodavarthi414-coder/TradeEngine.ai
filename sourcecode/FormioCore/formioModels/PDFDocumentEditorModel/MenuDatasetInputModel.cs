using MongoDB.Bson;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerModels.PDFDocumentEditorModel
{
    public class MenuDatasetInputModel
    {
        public string _id { get; set; }
        public object MongoResult { get; set; }
        public string TemplateId { get; set; }
        public string DataSource { get; set; }
        public string MongoQuery { get; set; }
        public bool Archive { get; set; }
        public DataSorceParams[] MongoParamsType { get; set; }
        public DataSourceDummyParamValues[] MongoDummyParams { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
    }
}
