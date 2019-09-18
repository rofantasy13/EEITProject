package product.daoImpl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.sql.Blob;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletContext;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import config.GlobalService;
import config.SystemUtils;
import product.Dao.productDao;
import product.model.productBean;

@Repository
public class productDaoImpl implements productDao {
	int pageNo = 0;
	SessionFactory factory;
	@Autowired
	ServletContext context;

	public SessionFactory getFactory() {
		return factory;
	}

	@Autowired
	public void setFactory(SessionFactory factory) {
		this.factory = factory;
	}

	public productDaoImpl() {
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<productBean> getAllProduct() {
		List<productBean> list = new ArrayList<productBean>();
		Session session = factory.getCurrentSession();
		String sql = "FROM productBean";
		int startPage = (pageNo - 1) * GlobalService.dataPerPage;
		list = session.createQuery(sql).setFirstResult(startPage).setMaxResults(GlobalService.dataPerPage).list();
		return list;
	}

	@Override
	public int insertNewProduct(productBean pb) {
		int n = 0;
		Session session = factory.getCurrentSession();
		session.save(pb);
		n++;
		return n;
	}

	@Override
	public productBean getProduct(int pId) {
		productBean pb = null;
		Session session = factory.getCurrentSession();
		String sql = "FROM productBean p WHERE p.pId=:pid";
		pb = (productBean) session.createQuery(sql).setParameter("pid", pId).uniqueResult();
		return pb;
	}

	@Override
	public Long getDataCount() {
		Long n = null;
		Session session = factory.getCurrentSession();
		String sql = "SELECT COUNT(*) FROM productBean";
		n = (Long) session.createQuery(sql).uniqueResult();
		return n;
	}

	@Override
	public int getPageNo() {
		return pageNo;
	}

	@Override
	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}

	@Override
	public int updateStock(int pId, int newStock) {
		int n = 0;
		Session session = factory.getCurrentSession();
		String sql = "UPDATE productBean b SET b.pInstock = :stock WHERE b.pId = :id";
		n = session.createQuery(sql).setParameter("stock", newStock).setParameter("id", pId).executeUpdate();
		return n;
	}

	@Override
	public void addProductDB() {
		Session session = factory.getCurrentSession();
		String line = "";
		String UTF8_BOM = "\uFEFF";
		String datPath = context.getRealPath("/WEB-INF/resource/data/product.dat");
		File file = new File(datPath);
		try (FileInputStream fis = new FileInputStream(file);
				InputStreamReader isr = new InputStreamReader(fis, "UTF8");
				BufferedReader br = new BufferedReader(isr);) {
			while ((line = br.readLine()) != null) {
				System.out.println("line=" + line);
				// 去除 UTF8_BOM: \uFEFF
				if (line.startsWith(UTF8_BOM)) {
					line = line.substring(1);
				}
				String[] token = line.split("\\|");
				productBean pb = new productBean();
				pb.setpArea(token[0].trim());
				pb.setpAvgRating(Double.parseDouble(token[1].trim()));
				pb.setpContent(token[2]);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Date dateRange = sdf.parse(token[3]);
				java.sql.Date sqldate = new java.sql.Date(dateRange.getTime());
				pb.setpDateRange(sqldate);
				String realPath = context.getRealPath(token[4].trim());
				Blob blob = SystemUtils.fileToBlob(realPath);
				pb.setpPicture(blob);
				pb.setpFileName(SystemUtils.extractFileName(token[4].trim()));
				pb.setpInstock(Integer.parseInt(token[5]));
				pb.setpName(token[6]);
				pb.setpPopular(Integer.parseInt(token[7]));
				pb.setpPrice(Integer.parseInt(token[8]));
				pb.setpRating(Integer.parseInt(token[9]));
				pb.setpType(token[10]);
				session.save(pb);
				System.out.println("新增一筆商品");
			}
			// 印出資料新增成功的訊息
			System.out.println("商品資料新增成功");
		} catch (Exception e) {
			System.err.println("新建表格時發生例外: " + e.getMessage());
			e.printStackTrace();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<productBean> getPopularFive() {
		Session session = factory.getCurrentSession();
		List<productBean> list = null;
		String hql = "FROM productBean pb ORDER BY pb.pAvgRating desc";
		list = session.createQuery(hql).setMaxResults(5).list();
		return list;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<productBean> getProductByPriceDesc(String QueryString) {
		List<productBean> list = new ArrayList<productBean>();
		Session session = factory.getCurrentSession();
		String sql = "";
		if (QueryString == null) {
			sql = "FROM productBean pb ORDER BY pb.pPrice desc";
			int startPage = (pageNo - 1) * GlobalService.dataPerPage;
			list = session.createQuery(sql).setFirstResult(startPage).setMaxResults(GlobalService.dataPerPage).list();
		} else {
			sql = "FROM productBean pb WHERE pb.pContent LIKE :query ORDER BY pb.pPrice desc";
			int startPage = (pageNo - 1) * GlobalService.dataPerPage;
			list = session.createQuery(sql).setParameter("query", "%" + QueryString + "%").setFirstResult(startPage)
					.setMaxResults(GlobalService.dataPerPage).list();
		}
		return list;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<productBean> getProductByPriceAsc(String QueryString) {
		List<productBean> list = new ArrayList<productBean>();
		Session session = factory.getCurrentSession();
		String sql = "";
		if (QueryString == null) {
			sql = "FROM productBean pb ORDER BY pb.pPrice";
			int startPage = (pageNo - 1) * GlobalService.dataPerPage;
			list = session.createQuery(sql).setFirstResult(startPage).setMaxResults(GlobalService.dataPerPage).list();
		} else {
			sql = "FROM productBean pb WHERE pb.pContent LIKE :query ORDER BY pb.pPrice";
			int startPage = (pageNo - 1) * GlobalService.dataPerPage;
			list = session.createQuery(sql).setParameter("query", "%" + QueryString + "%").setFirstResult(startPage)
					.setMaxResults(GlobalService.dataPerPage).list();
		}
		return list;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<productBean> getProductByReviewDesc(String QueryString) {
		List<productBean> list = new ArrayList<productBean>();
		Session session = factory.getCurrentSession();
		String sql = "";
		if (QueryString == null) {
			sql = "FROM productBean pb ORDER BY pb.pAvgRating desc";
			int startPage = (pageNo - 1) * GlobalService.dataPerPage;
			list = session.createQuery(sql).setFirstResult(startPage).setMaxResults(GlobalService.dataPerPage).list();
		} else {
			sql = "FROM productBean pb WHERE pb.pContent LIKE :query ORDER BY pb.pAvgRating desc";
			int startPage = (pageNo - 1) * GlobalService.dataPerPage;
			list = session.createQuery(sql).setParameter("query", "%" + QueryString + "%").setFirstResult(startPage)
					.setMaxResults(GlobalService.dataPerPage).list();
		}
		return list;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<productBean> getProductByReviewAsc(String QueryString) {
		List<productBean> list = new ArrayList<productBean>();
		Session session = factory.getCurrentSession();
		String sql = "";
		if (QueryString == null) {
			sql = "FROM productBean pb ORDER BY pb.pAvgRating";
			int startPage = (pageNo - 1) * GlobalService.dataPerPage;
			list = session.createQuery(sql).setFirstResult(startPage).setMaxResults(GlobalService.dataPerPage).list();
		} else {
			sql = "FROM productBean pb WHERE pb.pContent LIKE :query ORDER BY pb.pAvgRating";
			int startPage = (pageNo - 1) * GlobalService.dataPerPage;
			list = session.createQuery(sql).setParameter("query", "%" + QueryString + "%").setFirstResult(startPage)
					.setMaxResults(GlobalService.dataPerPage).list();
		}
		return list;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<productBean> QueryProduct(String QueryString) {
		List<productBean> list = new ArrayList<productBean>();
		Session session = factory.getCurrentSession();
		String sql = "FROM productBean pb WHERE pb.pContent LIKE :query";
		int startPage = (pageNo - 1) * GlobalService.dataPerPage;
		list = session.createQuery(sql).setParameter("query", "%" + QueryString + "%").setFirstResult(startPage)
				.setMaxResults(GlobalService.dataPerPage).list();
		return list;
	}

	@Override
	public Long getQueryCount(String QueryString) {
		Long n = null;
		Session session = factory.getCurrentSession();
		String sql = "SELECT COUNT(*) FROM productBean pb WHERE pb.pContent LIKE :query";
		n = (Long) session.createQuery(sql).setParameter("query", "%"+QueryString+"%").uniqueResult();
		return n;
	}

}
