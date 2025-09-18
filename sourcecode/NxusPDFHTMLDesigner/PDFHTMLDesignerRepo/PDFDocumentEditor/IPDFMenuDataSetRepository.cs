using MongoDB.Bson;
using MongoDB.Driver;
using PDFHTMLDesignerModels;
using PDFHTMLDesignerModels.DocumentModel;
using PDFHTMLDesignerModels.DocumentOutputModel;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using PDFHTMLDesignerModels.SFDTParameterModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerRepo.PDFDataSet
{
    public interface IPDFMenuDataSetRepository
    {
        //Guid? CreatePDFMenuDataSet(PDFDatasetInputModel pdfdatasetInputModel, string commodityName,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        //List<PDFDesignerDatasetOutputModel> GetAllPDFMenuDataSet(string TemplateId,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        //List<DataSetMenuModel> GetSelectedMenu(string GetSelectedMenu,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
