package com.lchjy.mapper;

import com.lchjy.entity.Guestbook;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface GuestbookMapper {
    List<Guestbook> selectList();

    int insert(Guestbook guestbook);

    int deleteById(Integer id);
}
