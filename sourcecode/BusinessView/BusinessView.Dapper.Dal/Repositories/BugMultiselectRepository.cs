using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class BugMultiselectRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the BugMultiselect table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(BugMultiselectDbEntity aBugMultiselect)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aBugMultiselect.Id);
					 int iResult = vConn.Execute("USP_BugMultiselectInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Selects all records from the BugMultiselect table.
		/// </summary>
		 public IEnumerable<BugMultiselectDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<BugMultiselectDbEntity>("USP_BugMultiselectSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
