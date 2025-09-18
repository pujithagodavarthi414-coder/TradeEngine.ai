using System;

namespace Btrak.Dapper.Dal.SpModels
{

    public class UserBreaksSpEntity
    {

        public Guid Id
        { get; set; }

        public Guid UserId
        { get; set; }

        public DateTime Date
        { get; set; }

        public bool IsOfficeBreak
        { get; set; }


        public DateTime? BreakIn
        { get; set; }


        public DateTime? BreakOut
        { get; set; }

        public string BreakDiff
        {
            get;
            set;
        }
    }
}
