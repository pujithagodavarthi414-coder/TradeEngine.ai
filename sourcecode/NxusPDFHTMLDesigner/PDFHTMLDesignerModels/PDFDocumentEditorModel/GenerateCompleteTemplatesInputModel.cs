using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerModels.PDFDocumentEditorModel
{
    public class GenerateCompleteTemplatesInputModel
    {
        public string SelectedFormDataJson { get; set; }
        public Guid TemplateId { get; set; }
        public Guid GenericFormSubmittedId { get; set; }
        public string InvoiceDowloadId { get; set; }

    }
}
