package com.lchjy.service;

import com.lchjy.entity.Guestbook;
import com.github.pagehelper.PageInfo;

public interface GuestbookService {
    PageInfo<Guestbook> list(int pageNum, int pageSize);

    void add(Guestbook guestbook);

    void delete(Integer id);
}
