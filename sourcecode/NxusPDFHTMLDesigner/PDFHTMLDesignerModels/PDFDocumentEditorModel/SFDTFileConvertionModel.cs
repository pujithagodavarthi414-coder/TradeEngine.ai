using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Bson;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using System.Text.Json.Serialization;

namespace PDFHTMLDesignerModels.SFDTFileConvertionModel
{
    public class SFDTFileConvertionModel
    {
        public string fileStreamBase64 { get; set; }
        public string filename { get; set; }
        public string filetype { get; set; }
    }
}
