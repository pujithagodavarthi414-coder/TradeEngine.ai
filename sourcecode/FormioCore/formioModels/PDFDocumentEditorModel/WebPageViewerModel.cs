using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.PDFDocumentEditorModel
{
    public class WebPageViewerModel
    {
        public Guid? _id { get; set; }
        public string Path { get; set; }
        public Guid TemplateId { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid CompanyId { get; set; }
        public bool? IsArchived { get; set; }
    }
}
