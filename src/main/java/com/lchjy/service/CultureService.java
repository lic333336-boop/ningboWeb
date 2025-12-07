package com.lchjy.service;

import com.lchjy.entity.NingboCulture;
import com.github.pagehelper.PageInfo;
import java.util.List;

public interface CultureService {
    PageInfo<NingboCulture> list(String keyword, int pageNum, int pageSize);

    NingboCulture getById(Integer id);

    void add(NingboCulture culture);

    void update(NingboCulture culture);

    void delete(Integer id);
}
