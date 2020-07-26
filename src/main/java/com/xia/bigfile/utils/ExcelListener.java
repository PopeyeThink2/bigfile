package com.xia.bigfile.utils;

import com.alibaba.excel.context.AnalysisContext;
import com.alibaba.excel.event.AnalysisEventListener;
import com.xia.bigfile.domain.FileData;
import com.xia.bigfile.repository.FileDataRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ExcelListener extends AnalysisEventListener<FileData> {

    @Autowired
    FileDataRepository fileDataRepository;

    private static final Logger LOGGER = LoggerFactory.getLogger(ExcelListener.class);
    /**
     * 每隔1000条存储数据库，然后清理list ，方便内存回收
     */
    private static final int BATCH_COUNT = 100000;
    private static Connection conn = JDBCUtil.getConnection();
    List<FileData> list = new ArrayList<FileData>();
    public ExcelListener() {

    }

    /**
     * 这个每一条数据解析都会来调用
     *
     * @param fileData
     *            one row value. Is is same as {@link AnalysisContext#readRowHolder()}
     * @param analysisContext
     */
    @Override
    public void invoke(FileData fileData, AnalysisContext analysisContext) {
        list.add(fileData);
        // 达到BATCH_COUNT了，需要去存储一次数据库，防止数据几万条数据在内存，容易OOM
        if (list.size() >= BATCH_COUNT) {
            saveData();
            // 存储完成清理 list
            list.clear();
        }
    }

    /**
     * 存储数据库
     */
    private void saveData() {
        LOGGER.info("{}条数据，开始存储数据库！", list.size());
        //System.out.println(list);
        importExcel();
        LOGGER.info("存储数据库成功！");
    }

    @Override
    public void doAfterAllAnalysed(AnalysisContext analysisContext) {

    }

    public void importExcel(){
        PreparedStatement ps = null;
        try {
            //关闭自动提交，即开启事务
            conn.setAutoCommit(false);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        String sql = "insert into filedata values (?,?,?) ";
        try {
            //创建语句对象
            ps = conn.prepareStatement(sql);
            for(int i = 0; i < list.size(); i++){
                FileData md = list.get(i);
                ps.setString(1,md.getId());
                ps.setString(2,md.getName());
                ps.setString(3,md.getDate());
                ps.addBatch();

                if (i > 0 && i % BATCH_COUNT == 0 ) {
                    // 语句执行完毕，提交本事务
                    ps.executeBatch();
                    ps.clearBatch();
                    // 此处的事务回滚是必须的
                    try {
                        conn.commit();
                    } catch (Exception e) {
                        conn.rollback();
                    }
                }
            }
            // 如果数据不为倍数的话，最后一次会剩下一些
            // 语句执行完毕，提交本事务
            ps.executeBatch();
            ps.clearBatch();
            try {
                conn.commit();
            } catch (Exception e) {
                conn.rollback();
            }
            // 在把自动提交打开
            conn.setAutoCommit(true);
        }catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCUtil.close(null,ps,null);
        }

    }
}
