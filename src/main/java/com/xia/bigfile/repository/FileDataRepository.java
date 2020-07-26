package com.xia.bigfile.repository;

import com.xia.bigfile.domain.FileData;
import org.springframework.data.jpa.repository.JpaRepository;


public interface FileDataRepository extends JpaRepository<FileData, String> {

}
