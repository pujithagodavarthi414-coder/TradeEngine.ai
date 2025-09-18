using PDFHTMLDesignerModels.HTMLDocumentEditorModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerModels.PDFDocumentEditorModel
{
    public class WebTemplateOutputModel
    {
        public Guid TemplateId { get; set; }
        public List<WebHtmlTemplateOutputModel> HtmlFiles { get; set; }
        public string SfdtFile { get; set; }
        public string TemplateType { get; set; }
        public List<TemplateTagStylesModel> TemplateTagStyles {  get; set; }
        public bool? AllowAnonymous { get; set; }
    }
}
