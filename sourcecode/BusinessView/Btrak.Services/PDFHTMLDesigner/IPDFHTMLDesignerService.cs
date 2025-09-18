using BTrak.Common;
using Btrak.Models.GenericForm;
using Btrak.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.PDFHTMLDesigner
{
    public interface IPDFHTMLDesignerService
    {
      Task<List<FileConvertionOutputModel>> FileConvertion(List<FileConvertionInputModel> InputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
      Task<string> ByteArrayToPDFConvertion(ShareDashBoardAsPDFInputModel InputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
    }
}
