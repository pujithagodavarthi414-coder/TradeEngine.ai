using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.MailTemplateActivity
{
    public interface IMailTemplateActivityService
    {
        void SendMail(string sqlConectionString, LoggedInContext loggedInContext, EmailGenericModel emailGenericModel);
    }
}
