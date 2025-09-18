using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
    public class SendGeneratedReporttoMailInputModel
    {
       public List<FileConvertionInputModel> FileModel {  get; set; }
        public string[] ToAddresses { get; set; }
        public string Message { get; set; }
        public string Subject { get; set; }
        public string[] CCMails { get; set; }
        public string[] BCCMails { get; set; }
    }
    public class FileConvertionInputModel
    {
        public string GeneratedInvoicesId { get; set; }
        public string SfdtJson { get; set; }
        public string FileName { get; set; }
        public string Filetype { get; set; }
        public Guid? FileId { get; set; }
        public string FilePath { get; set; }
        public string FileExtension { get; set; }
        public bool IsSfdtFile { get; set; }
    }
    public class FileConvertionOutputModel
    {
        public string GeneratedInvoicesId { get; set; }
        public string FileName { get; set; }
        public string FilePath { get; set; }
        public string FileType { get; set; }
    }
}
