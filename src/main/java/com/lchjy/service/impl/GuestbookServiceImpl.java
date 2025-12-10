package com.lchjy.service.impl;

import com.lchjy.entity.Guestbook;
import com.lchjy.mapper.GuestbookMapper;
import com.lchjy.service.GuestbookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import java.util.List;

@Service
public class GuestbookServiceImpl implements GuestbookService {

    @Autowired
    private GuestbookMapper guestbookMapper;

    @Override
    public PageInfo<Guestbook> list(int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Guestbook> list = guestbookMapper.selectList();
        return new PageInfo<>(list);
    }

    @Override
    public void add(Guestbook guestbook) {
        guestbookMapper.insert(guestbook);
    }

    @Override
    public void delete(Integer id) {
        guestbookMapper.deleteById(id);
    }
}
