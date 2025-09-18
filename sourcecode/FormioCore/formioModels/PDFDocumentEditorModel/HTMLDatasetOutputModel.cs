using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerModels.HTMLDocumentEditorModel
{
    public class HTMLDatasetOutputModel
    {
        public Guid? _id { get; set; }
        public string HTMLFile { get; set; }
    }

    public class TemplateOutputModel
    {
        public Guid _id { get; set; }
        public string FileType { get; set; }
        public string FileName { get; set; }
        public string HTMLFile { get; set; }
        public string SfdtJson { get; set; }
        public List<TemplateTagStylesModel> TemplateTagStyles { get; set; }
        public List<TemplatePermissionsModel> TemplatePermissions { get; set; }

        public DateTime CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public bool IsArchived { get; set; }
        public string DataSources { get; set; }
        public string TemplateType { get; set; }
        public bool? AllowAnonymous { get; set; }

    }
    public class GenerateCompleteTemplatesOutputModel
    {
        public Guid? _id { get; set; }
        public string InvoiceDowloadId { get; set; }
        public Guid GenericFormSubmittedId { get; set; }
        public string SfdtTemplatesToDownload { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
    }
}
