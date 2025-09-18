using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmployeeLanguageRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the EmployeeLanguage table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(EmployeeLanguageDbEntity aEmployeeLanguage)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeLanguage.Id);
					 vParams.Add("@EmployeeId",aEmployeeLanguage.EmployeeId);
					 vParams.Add("@LanguageId",aEmployeeLanguage.LanguageId);
					 vParams.Add("@FluencyId",aEmployeeLanguage.FluencyId);
					 vParams.Add("@CompetencyId",aEmployeeLanguage.CompetencyId);
					 vParams.Add("@Comments",aEmployeeLanguage.Comments);
					 vParams.Add("@CreatedDateTime",aEmployeeLanguage.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeLanguage.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeLanguage.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeLanguage.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeLanguageInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the EmployeeLanguage table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(EmployeeLanguageDbEntity aEmployeeLanguage)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeLanguage.Id);
					 vParams.Add("@EmployeeId",aEmployeeLanguage.EmployeeId);
					 vParams.Add("@LanguageId",aEmployeeLanguage.LanguageId);
					 vParams.Add("@FluencyId",aEmployeeLanguage.FluencyId);
					 vParams.Add("@CompetencyId",aEmployeeLanguage.CompetencyId);
					 vParams.Add("@Comments",aEmployeeLanguage.Comments);
					 vParams.Add("@CreatedDateTime",aEmployeeLanguage.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeLanguage.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeLanguage.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeLanguage.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeLanguageUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of EmployeeLanguage table.
		/// </summary>
		public EmployeeLanguageDbEntity GetEmployeeLanguage(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<EmployeeLanguageDbEntity>("USP_EmployeeLanguageSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeLanguage table.
		/// </summary>
		 public IEnumerable<EmployeeLanguageDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmployeeLanguageDbEntity>("USP_EmployeeLanguageSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the EmployeeLanguage table by a foreign key.
		/// </summary>
		public List<EmployeeLanguageDbEntity> SelectAllByEmployeeId(Guid employeeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@EmployeeId",employeeId);
				 return vConn.Query<EmployeeLanguageDbEntity>("USP_EmployeeLanguageSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeLanguage table by a foreign key.
		/// </summary>
		public List<EmployeeLanguageDbEntity> SelectAllByCompetencyId(Guid competencyId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CompetencyId",competencyId);
				 return vConn.Query<EmployeeLanguageDbEntity>("USP_EmployeeLanguageSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeLanguage table by a foreign key.
		/// </summary>
		public List<EmployeeLanguageDbEntity> SelectAllByFluencyId(Guid fluencyId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@FluencyId",fluencyId);
				 return vConn.Query<EmployeeLanguageDbEntity>("USP_EmployeeLanguageSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeLanguage table by a foreign key.
		/// </summary>
		public List<EmployeeLanguageDbEntity> SelectAllByLanguageId(Guid languageId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@LanguageId",languageId);
				 return vConn.Query<EmployeeLanguageDbEntity>("USP_EmployeeLanguageSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
