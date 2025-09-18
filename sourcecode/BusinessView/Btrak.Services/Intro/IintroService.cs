using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.Intro
{
    public interface IIntroService
    {
        List<IntroOutputModel> GetIntro(IntroOutputModel intromodel, List<ValidationMessage> validationMessages, LoggedInContext loggedInContext);
        Guid? UpsertIntro(IntroOutputModel intromodel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
