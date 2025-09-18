using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerModels.PDFDocumentEditorModel
{
    public  class WebTemplateInputModel
    {
        public Guid TemplateId { get; set; }
        public Guid? GenericFormSubmittedId { get; set; }
        public string? RoleId { get; set; }
    }
    public class FileConvertionInputModel
    {
        public string GeneratedInvoicesId { get; set; }
        public string SfdtJson { get; set; }
        public string FileName { get; set; }
        public string Filetype { get; set; }
    }
    public class FileConvertionOutputModel
    {
        public string GeneratedInvoicesId { get; set; }
        public string FileName { get; set; }
        public string Filetype { get; set; }
        public string FilePath { get; set; }
    }
    public class ByteArrayToPDFConvertion
    {
        public List<FileBytesModel> FileBytes { get; set; }
        public string DashboadName { get; set; }
    }
    public class FileBytesModel
    {
        public string VisualizationName { get; set; }
        public string FileType { get; set; }
        public string FileByteStrings { get; set; }
    }
}
