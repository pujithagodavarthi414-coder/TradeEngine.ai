using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerModels.HTMLDocumentEditorModel
{
    public class HTMLDatasetInputModel
    {
        public Guid? _id { get; set; }
        public string FileType { get; set; }
        public string FileId { get; set; }
        public string FileName { get; set; }
        public string TemplateType { get; set; }
        public string HTMLFile { get; set; }
        public string SfdtJson { get; set; }
        public string DataSources { get; set; }
        public List<TemplateTagStylesModel> TemplateTagStyles { get; set; }

        public Guid CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        public DateTime ArchivedDateTime { get; set; }
        public bool IsArchived { get; set; }
    }

    public class HTMLDatasetEditModel
    {
        public string _id { get; set; }
        public byte[] SFDTFile { get; set; }
        public string SfdtJson { get; set; }
        public string FileName { get; set; }
        public string TemplateType { get; set; }
        public string DataSources { get; set; }
        public string HtmlJson { get; set; }
        public bool? AllowAnonymous { get; set; }
        public List<TemplateTagStylesModel> TemplateTagStyles { get; set; }
        public List<TemplatePermissionsModel> TemplatePermissions { get; set; }
    }

    public class HTMLDatasetsaveModel
    {
        public byte[] SFDTFile { get; set; }
        public string SfdtJson { get; set; }
        public string FileName { get; set; }
        public string TemplateType { get; set; }
        public Guid? _id { get; set; }
        public string DataSources {get;set;}
        public bool? AllowAnonymous { get; set; }
        public List<TemplateTagStylesModel> TemplateTagStyles { get; set; }
        public List<TemplatePermissionsModel> TemplatePermissions { get; set; }


    }
    public class TemplateTagStylesModel
    {
        public string TagName { get; set; }
        public string Type { get; set; }
        public string Style { get; set; }

    }
    public class TemplatePermissionsModel
    {
        public Guid? RoleId { get; set; }
        public string RoleName { get; set; }
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public string Permission { get; set; }
    }
}
